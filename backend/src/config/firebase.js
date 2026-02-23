import admin from 'firebase-admin';
import { env } from './env.js';

const app = admin.apps.length
  ? admin.app()
  : admin.initializeApp({
      credential: admin.credential.cert({
        projectId: env.firebaseProjectId,
        clientEmail: env.firebaseClientEmail,
        privateKey: env.firebasePrivateKey
      })
    });

export const firestore = app.firestore();
export const FieldValue = admin.firestore.FieldValue;
