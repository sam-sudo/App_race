import express from 'express';
const router = express.Router();
import raceControler from '../controllers/raceController';
import userController from '../controllers/userController';

router.post('/save-race', userController.validateToken,raceControler.saveRace);
router.get('/race/:id', userController.validateToken,raceControler.getRace);
router.get('/races', raceControler.getRaces);
router.get('/my_races/:email', userController.validateToken,raceControler.getMyRaces);
router.put('/update-race/:id', userController.validateToken,raceControler.updateRace);
router.delete('/delete-race/:id', userController.validateToken,raceControler.deleteRace);

export default router;