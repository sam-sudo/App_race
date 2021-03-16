import mongoose, { Collection } from 'mongoose';
const Schema = mongoose.Schema;

const RaceSchema = new Schema({
  name: {
    type: String,
    required: true
  },
  description: {
    type: String,
    required: true
  },
  runners: {
    type: {type : Schema.ObjetId, ref:"User"},
    required: false
  },
  routePoints: {
    type: Array,
    required: false
  },
  dateRace: {
    type: Date,
    required: true
  }
});

const Race = mongoose.model('Race', RaceSchema);

export default Race