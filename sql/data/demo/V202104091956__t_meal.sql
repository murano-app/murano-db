UPDATE public.t_meal
SET image_url='https://murano.blob.core.windows.net/murano-container/photo5350450965372843006.jpg'
WHERE id in (SELECT tm.id
             FROM public.t_meal tm
                      JOIN t_category tc ON tc.id = tm.category_id
             WHERE tc.priority in (1, 2))
