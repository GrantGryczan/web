execute positioned ~ ~-1 ~ if predicate fast_leaf_decay:leaves/4 unless entity @e[type=minecraft:area_effect_cloud,tag=leafDec.marker,distance=..0.1] run function fast_leaf_decay:iterate
execute positioned ~ ~1 ~ if predicate fast_leaf_decay:leaves/4 unless entity @e[type=minecraft:area_effect_cloud,tag=leafDec.marker,distance=..0.1] run function fast_leaf_decay:iterate
execute positioned ~-1 ~ ~ if predicate fast_leaf_decay:leaves/4 unless entity @e[type=minecraft:area_effect_cloud,tag=leafDec.marker,distance=..0.1] run function fast_leaf_decay:iterate
execute positioned ~1 ~ ~ if predicate fast_leaf_decay:leaves/4 unless entity @e[type=minecraft:area_effect_cloud,tag=leafDec.marker,distance=..0.1] run function fast_leaf_decay:iterate
execute positioned ~ ~ ~-1 if predicate fast_leaf_decay:leaves/4 unless entity @e[type=minecraft:area_effect_cloud,tag=leafDec.marker,distance=..0.1] run function fast_leaf_decay:iterate
execute positioned ~ ~ ~1 if predicate fast_leaf_decay:leaves/4 unless entity @e[type=minecraft:area_effect_cloud,tag=leafDec.marker,distance=..0.1] run function fast_leaf_decay:iterate