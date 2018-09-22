module Haskex.ADT where

import Prelude

class Functor f => PriorityQueue f where
  pqPush :: Ord b => b -> f b -> f b
  pqPop  :: Ord b => f b -> Maybe (b, f b)
