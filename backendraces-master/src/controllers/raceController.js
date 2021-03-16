import Race from '../models/race.model';
import Circuit from '../models/circuit.model';

const raceController = {

  getRaces: async (req, res) => {
    const {body} = req
    console.log(body);
    
    try {
      const race = await Race.find();
      res
        .status(200)
        .json(race);
    } catch (error) {
      res
        .status(400)
        .json({
          message: err
        });
    }
  },
  getMyRaces: async (req, res) => {
    const _email = req.params.email;
    try {
      const circuit = await Race.find({'runners.email':_email})
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
  saveRace: async (req, res) => {
    const body = req.body;    
    try {
      const savedRace = await Race.create(body);
      res
        .status(201)
        .json(savedRace);
    } catch (err) {
      res
        .status(500)
        .json({
          message: err
        });
    }
  },
  getRace: async (req, res) => {
    const _id = req.params.id;
    try {
      const race = await Race.findOne({_id});
      res
        .status(200)
        .json(race)
    } catch (err) {
      res
        .status(400)
        .json({
          message: err
        })
    }
  },
  deleteRace: async (req, res) => {
    const _id = req.params.id;
    try {
      const revomedRace = await Race.findByIdAndDelete({_id});

      if (!revomedRace) {
        return res.status(404).json({
          message: err
        })
      }

      res.json(revomedRace)
    } catch (err) {
      res
        .status(400)
        .json({
          message: err
        })
    }
  },
  updateRace: async (req, res) => {
    const _id = req.params.id;
    const body = req.body;
    try {
      const updatedRace = await Race.findByIdAndUpdate(
        _id,
        body,
        {new: true});

      if (!updatedRace) {
        return res.status(404).json({
          message: err
        })
      }
      res
        .status(200)
        .json(updatedRace)
    } catch (err) {
      res
        .status(500)
        .json({
          message: err
        })
    }
  }
};

export default raceController;