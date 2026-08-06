import express from 'express';
import cors from 'cors';
import mundoRoutes from './routes/mundoRoutes';
import usuarioRoutes from './routes/usuarioRoutes';
import recuperarRoutes from './routes/recuperarRoutes';

const app = express();

app.use(cors());
app.use(express.json());
app.use('/api', usuarioRoutes);
app.use('/api', mundoRoutes);
app.use('/api', recuperarRoutes);
export default app;