import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();

// ─────────────────────────────────────────────────────────────────────────────
// 1. On Transaction Status Updated → Update Balances & Notify
// ─────────────────────────────────────────────────────────────────────────────
export const onTransactionUpdated = functions.firestore
  .document("groups/{groupId}/transactions/{transactionId}")
  .onUpdate(async (change, context) => {
    const groupId = context.params.groupId;
    const transactionId = context.params.transactionId;
    const before = change.before.data();
    const after = change.after.data();

    // Only process when status changes to "approved"
    if (before.status === "approved" || after.status !== "approved") {
      return null;
    }

    const creditorId: string = after.creditorUserId;
    const debtorId: string = after.debtorUserId;
    const amount: number = after.amount;
    const currency: string = after.currency;
    const note: string = after.note || "";

    const groupRef = db.collection("groups").doc(groupId);

    // ── Update balances atomically ────────────────────────────
    await db.runTransaction(async (transaction) => {
      const groupDoc = await transaction.get(groupRef);
      if (!groupDoc.exists) {
        throw new Error(`Group ${groupId} not found`);
      }

      const groupData = groupDoc.data()!;
      const balances: Record<string, number> = groupData.balances || {};

      if (after.type === "loan") {
        // Creditor is owed more, debtor owes more
        balances[creditorId] = (balances[creditorId] || 0) + amount;
        balances[debtorId] = (balances[debtorId] || 0) - amount;
      } else if (after.type === "repayment") {
        // Repayment: debtor pays back creditor
        balances[creditorId] = (balances[creditorId] || 0) - amount;
        balances[debtorId] = (balances[debtorId] || 0) + amount;
      }
      // "correction" type can be handled with custom logic

      transaction.update(groupRef, { balances });
    });

    // ── Create Audit Log ──────────────────────────────────────
    const auditRef = groupRef.collection("auditLogs").doc();
    await auditRef.set({
      id: auditRef.id,
      groupId,
      transactionId,
      actorUserId: after.createdByUserId,
      action: "transaction_approved",
      detailsJson: {
        type: after.type,
        amount,
        currency,
        creditorUserId: creditorId,
        debtorUserId: debtorId,
      },
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // ── Send Notifications ────────────────────────────────────
    const notifyUsers = [creditorId, debtorId];
    const batch = db.batch();

    for (const userId of notifyUsers) {
      const notifRef = db
        .collection("users")
        .doc(userId)
        .collection("notifications")
        .doc();

      batch.set(notifRef, {
        id: notifRef.id,
        userId,
        groupId,
        transactionId,
        type: "TransactionApproved",
        title: "Transaction Approved",
        message: `${after.type} of ${amount} ${currency} has been approved${note ? `: ${note}` : ""}.`,
        isRead: false,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
    return null;
  });

// ─────────────────────────────────────────────────────────────────────────────
// 2. On Transaction Rejected → Notify Creator
// ─────────────────────────────────────────────────────────────────────────────
export const onTransactionRejected = functions.firestore
  .document("groups/{groupId}/transactions/{transactionId}")
  .onUpdate(async (change, context) => {
    const groupId = context.params.groupId;
    const transactionId = context.params.transactionId;
    const before = change.before.data();
    const after = change.after.data();

    if (before.status === "rejected" || after.status !== "rejected") {
      return null;
    }

    const creatorId: string = after.createdByUserId;
    const amount: number = after.amount;
    const currency: string = after.currency;

    // Notify the creator
    const notifRef = db
      .collection("users")
      .doc(creatorId)
      .collection("notifications")
      .doc();

    await notifRef.set({
      id: notifRef.id,
      userId: creatorId,
      groupId,
      transactionId,
      type: "TransactionRejected",
      title: "Transaction Rejected",
      message: `Your ${after.type} of ${amount} ${currency} has been rejected.`,
      isRead: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Audit log
    const auditRef = db
      .collection("groups")
      .doc(groupId)
      .collection("auditLogs")
      .doc();

    await auditRef.set({
      id: auditRef.id,
      groupId,
      transactionId,
      actorUserId: creatorId,
      action: "transaction_rejected",
      detailsJson: {
        type: after.type,
        amount,
        currency,
      },
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return null;
  });

// ─────────────────────────────────────────────────────────────────────────────
// 3. On Transaction Created → Send Approval Request Notification
// ─────────────────────────────────────────────────────────────────────────────
export const onTransactionCreated = functions.firestore
  .document("groups/{groupId}/transactions/{transactionId}")
  .onCreate(async (snapshot, context) => {
    const groupId = context.params.groupId;
    const transactionId = context.params.transactionId;
    const data = snapshot.data();

    const creditorId: string = data.creditorUserId;
    const debtorId: string = data.debtorUserId;
    const creatorId: string = data.createdByUserId;
    const amount: number = data.amount;
    const currency: string = data.currency;
    const note: string = data.note || "";

    // Notify the other party (the one who didn't create the transaction)
    const notifyUserId =
      creatorId === creditorId ? debtorId : creditorId;

    const notifRef = db
      .collection("users")
      .doc(notifyUserId)
      .collection("notifications")
      .doc();

    await notifRef.set({
      id: notifRef.id,
      userId: notifyUserId,
      groupId,
      transactionId,
      type: "ApprovalRequest",
      title: "New Transaction Request",
      message: `${data.createdByName || "Someone"} created a ${data.type} of ${amount} ${currency}${note ? ` for: ${note}` : ""}.`,
      isRead: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return null;
  });

// ─────────────────────────────────────────────────────────────────────────────
// 4. On User Created (Auth Trigger) → Create User Document
// ─────────────────────────────────────────────────────────────────────────────
export const onUserCreated = functions.auth.user().onCreate(async (user) => {
  const userRef = db.collection("users").doc(user.uid);
  const existing = await userRef.get();

  if (!existing.exists) {
    await userRef.set({
      id: user.uid,
      fullName: user.displayName || "",
      email: user.email || "",
      authProvider: user.providerData[0]?.providerId || "email",
      providerId: user.uid,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  }
});
