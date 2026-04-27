import 'dotenv/config';
import mongoose from 'mongoose';

const MONGO_URI = process.env.MONGO_URI;

async function fixLensGroupIndex() {
    try {
        await mongoose.connect(MONGO_URI);
        console.log('✅ Connected to MongoDB.');

        const db = mongoose.connection.db;
        const collection = db.collection('lensgroups');

        // List current indexes
        const indexes = await collection.indexes();
        console.log('\nCurrent indexes on lensgroups:');
        indexes.forEach(idx => console.log(' -', idx.name, ':', JSON.stringify(idx.key)));

        // Step 1: Drop the old global unique index on productName alone
        const oldIndex = indexes.find(idx => idx.name === 'productName_1');
        if (oldIndex) {
            await collection.dropIndex('productName_1');
            console.log('\n✅ Dropped old global unique index "productName_1"');
        } else {
            console.log('\nℹ️  Index "productName_1" not found — may already be dropped or renamed.');
        }

        // Step 2: Create the correct compound per-company unique index
        // sparse: true so null companyId values are handled gracefully
        const newIndexName = 'productName_1_companyId_1';
        const existingNew = indexes.find(idx => idx.name === newIndexName);
        if (!existingNew) {
            await collection.createIndex(
                { productName: 1, companyId: 1 },
                { unique: true, sparse: true, name: newIndexName }
            );
            console.log('✅ Created new compound index "productName_1_companyId_1"');
        } else {
            console.log('ℹ️  Compound index "productName_1_companyId_1" already exists — skipping creation.');
        }

        // Confirm final state
        const finalIndexes = await collection.indexes();
        console.log('\nFinal indexes on lensgroups:');
        finalIndexes.forEach(idx => console.log(' -', idx.name, ':', JSON.stringify(idx.key)));

    } catch (err) {
        console.error('❌ Error:', err.message);
        process.exit(1);
    } finally {
        await mongoose.disconnect();
        console.log('\n✅ Disconnected from MongoDB.');
    }
}

fixLensGroupIndex();
