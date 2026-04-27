import mongoose from "mongoose";

const PowerRangeLibrarySchema = new mongoose.Schema({
    companyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Company', default: null },
    groupName: { type: String, required: true }, // Strictly isolated by group
    sphMin: { type: Number, default: 0 },
    sphMax: { type: Number, default: 0 },
    sphStep: { type: Number, default: 0.25 },
    cylMin: { type: Number, default: 0 },
    cylMax: { type: Number, default: 0 },
    cylStep: { type: Number, default: 0.25 },
    addMin: { type: Number, default: 0 },
    addMax: { type: Number, default: 0 },
    addStep: { type: Number, default: 0.25 },
    axis: { type: Number, default: 0 },
    label: { type: String, required: true },
}, {
    timestamps: true
});

// Ensure uniqueness per company AND group for the same range values.
// This allows identical power ranges to exist separately for different groups.
PowerRangeLibrarySchema.index({
    companyId: 1,
    groupName: 1,
    sphMin: 1, sphMax: 1,
    cylMin: 1, cylMax: 1,
    addMin: 1, addMax: 1,
    axis: 1
}, { unique: true });

const PowerRangeLibrary = mongoose.model("PowerRangeLibrary", PowerRangeLibrarySchema);
export default PowerRangeLibrary;
