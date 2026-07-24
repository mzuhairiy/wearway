# Product images

Drop 60 fashion product photos here (Unsplash/Pexels, licensed for use).

**Naming:** must match the product id from the seed:
- Primary: `{productId}.jpg` (e.g. `prod_tshirt_black_01.jpg`)
- Optional secondary (carousel): `{productId}_2.jpg`

Product ids are generated deterministically in
`lib/data/seed/product_seed.dart`. To list them, run the app once and check
the seed, or grep the generated ids.

Until images are added, the app shows a placeholder (shirt icon) via
`ProductImage` — no crash. Recommended size: 600×600 (square), < 200 KB each.
