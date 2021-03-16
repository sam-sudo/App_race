import Circuit from '../models/circuit.model';

const circuitController = {

  getCircuits: async (req, res) => {
    try {
      const circuit = await Circuit.find();
      res
        .status(200)
        .json(circuit);
    } catch (error) {
      res
        .status(400)
        .json({
          message: err
        });
    }
  },
  getMyCircuits: async (req, res) => {
    var _email = req.params.email;
    try {
      const circuit = await Circuit.find({'emailUser': _email});
      res
        .status(200)
        .json(circuit);
    } catch (error) {
      res
        .status(400)
        .json({
          message: 'fail myraces'
        });
    }
  },
  saveCircuit: async (req, res) => {
    const body = req.body;    
    try {
      const savedCircuit = await Circuit.create(body);
      res
        .status(201)
        .json(savedCircuit);
    } catch (err) {
      res
        .status(500)
        .json({
          message: err
        });
    }
  },
  getCircuit: async (req, res) => {
    const _id = req.params.id;
    try {
      const circuit = await Circuit.findOne({_id});
      res
        .status(200)
        .json(circuit)
    } catch (err) {
      res
        .status(400)
        .json({
          message: err
        })
    }
  },
  deleteCircuit: async (req, res) => {
    const _id = req.params.id;
    try {
      const revomedCircuit = await Circuit.findByIdAndDelete({_id});

      if (!revomedRace) {
        return res.status(404).json({
          message: err
        })
      }

      res.json(revomedCircuit)
    } catch (err) {
      res
        .status(400)
        .json({
          message: err
        })
    }
  },
  updateCircuit: async (req, res) => {
    const _id = req.params.id;
    const body = req.body;
    try {
      const updatedCircuit = await Circuit.findByIdAndUpdate(
        _id,
        body,
        {new: true});

      if (!updatedCircuit) {
        return res.status(404).json({
          message: err
        })
      }
      res
        .status(200)
        .json(updatedCircuit)
    } catch (err) {
      res
        .status(500)
        .json({
          message: err
        })
    }
  }
};

export default circuitController;