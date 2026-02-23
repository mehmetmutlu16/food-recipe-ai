import { Router } from 'express';

const router = Router();

router.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    service: 'ancienda-recipe-backend',
    now: new Date().toISOString()
  });
});

export { router as healthRoutes };
