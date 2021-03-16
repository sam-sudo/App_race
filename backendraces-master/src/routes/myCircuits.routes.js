import express from 'express';
const router = express.Router();
import myCircuitsControler from '../controllers/myCircuitsController';

router.get('/circuits', myCircuitsControler.getCircuits);
router.get('/myCircuits/:email', myCircuitsControler.getMyCircuits);
router.get('/circuits/:id', myCircuitsControler.getCircuit);
router.post('/save_circuit', myCircuitsControler.saveCircuit);
router.delete('/delete_circuit/:id', myCircuitsControler.deleteCircuit);
router.put('/update_circuit/:id', myCircuitsControler.updateCircuit);


export default router;