import mongoose, { Collection } from 'mongoose';
import bcrypt from 'bcrypt'
const Schema = mongoose.Schema;

const userSchema = new Schema({
  email: {
    type: String,
    unique: true,
    required: true
  },
  password: {
    type: String,
    required: true,
    minlength: 3
  }
});

userSchema.pre('save',async function (next) {
  this.password = await bcrypt.hash(this.password, 8);
});

const User = mongoose.model('User', userSchema);

export default User