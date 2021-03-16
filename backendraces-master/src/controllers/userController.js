import User from '../models/user'
import bcrypt from 'bcrypt'
import jwt from 'jsonwebtoken'

const userController = {
    saveUser : async (req,res) => {
        const {body} = req
        try {
            const newUser = await User.create(body)
            res
              .status(201)
              .json(newUser);
          } catch (err) {
            res
              .status(500)
              .json({
                message: 'User duplicate'
              })
          }
    },
    loginUser: async (req,res) => {
        const {email} = req.body
        const {password} = req.body
    
        console.log(typeof password)
        

    try {
        const user = await User.findOne({email: email})
        if (!user) {
            return res.status(404).json({
              message: 'User not exist'
            })
          }
          if (!await bcrypt.compare(password , user.password )) {
            return res.status(404).json({
              message: 'Incorrect password'
            })
          }
          const token = jwt.sign({email: user.email}, process.env.SECRET_KEY, { expiresIn: '1h' });
          res
                .status(200)
                .json({
                  message: 'correct user',
                  token: token
                })

    } catch (error) {
        res
                .status(400)
                .json({error: err})
    }
    },
    validateToken: (req, res, next) => {
        if(!req.headers.authorization){
          return res
                      .status(401)
                      .json({error:'Unauthoried'})
        }

        try {
          const token = jwt.verify(req.headers.authorization,process.env.SECRET_KEY)
          req.body.user = token.login
          console.log(token)
          
          next()
        } catch (error) {
          return res
                      .status(400)
                      .json({error:'Not valid token'})
        }

        
    }
}

export default userController