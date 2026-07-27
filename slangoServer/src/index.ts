import express from 'express';
import cors from 'cors';
import mundoRoutes from './routes/mundoRoutes';
import 'dotenv/config';

const app = express();

app.use(cors());
app.use(express.json());
app.use('/api', mundoRoutes);

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`🚀 Servidor rodando na porta ${PORT}`);
});