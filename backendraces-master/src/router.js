import raceRoutes from './routes/race.routes'
import circuitRoutes from './routes/myCircuits.routes'
import userRouter from './routes/user_router'
import userController from './controllers/userController'


export default (app) => {

    app.get('/', async (req, res) => {
        res.send('Servicio para RaceApp');
    });

    app.use('/api_race',  raceRoutes);
    app.use('/api_circuit', userController.validateToken, circuitRoutes);
    app.use('/api_user', userRouter);
  
  }