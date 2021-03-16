import mongoose, { Collection } from 'mongoose';
const Schema = mongoose.Schema;

const RaceSchema = new Schema({
  name: {
    type: String,
    required: true
  },
  emailUser: {
    type: String,
    required: true
  },
  description: {
    type: String,
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

const Race = mongoose.model('Circuits', RaceSchema);

export default Race