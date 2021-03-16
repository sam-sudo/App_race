import express from 'express';
const router = express.Router();
import userControler from '../controllers/userController';

router.post('/signup', userControler.saveUser);
router.post('/login', userControler.loginUser);


export default router;