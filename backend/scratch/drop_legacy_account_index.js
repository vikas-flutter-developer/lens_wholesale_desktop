import mongoose from 'mongoose';
import dotenv from 'dotenv';
dotenv.config();

async function dropLegacyIndex() {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log("Connected to MongoDB");

    const collection = mongoose.connection.collection('accounts');
    
    // List all indexes to be sure
    const indexes = await collection.indexes();
    console.log("Current indexes:", JSON.stringify(indexes, null, 2));

    const hasLegacyIndex = indexes.some(idx => idx.name === 'AccountId_1');

    if (hasLegacyIndex) {
      console.log("Dropping legacy global unique index 'AccountId_1'...");
      await collection.dropIndex('AccountId_1');
      console.log("Index dropped successfully.");
    } else {
      console.log("Legacy index 'AccountId_1' not found. It might have already been dropped or has a different name.");
    }

    await mongoose.disconnect();
    console.log("Disconnected.");
  } catch (err) {
    console.error("Error dropping index:", err);
    process.exit(1);
  }
}

dropLegacyIndex();
