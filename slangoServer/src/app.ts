import express from 'express';
import cors from 'cors';
import mundoRoutes from './routes/mundoRoutes';

const app = express();

app.use(cors());
app.use(express.json());
app.use('/api', mundoRoutes);

export default app;