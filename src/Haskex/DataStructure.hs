module Haskex.DataStructure where

import Prelude
import Control.Lens hiding (snoc)
import Haskex.ADT

newtype Heap a
  = Heap
  { _struct :: Vector a
  }

heapify :: Ord a => Vector a -> Heap a
heapify a = mempty <> Heap a

heapPush :: Ord a => a -> Heap a -> Heap a
heapPush a = bubbleUp . heapPushInvalid a

heapPushInvalid :: Ord a => a -> Heap a -> Heap a
heapPushInvalid a (Heap vec) = Heap $ snoc vec a

rightChild :: Ord a -> Int -> Heap a -> Maybe (Int, a)
rightChild index heap = do
  let
    newIndex = 2 * index + 2
  mValue <- heap ^? ix newIndex
  pure (newIndex, mValue)

leftChild :: Ord a -> Int -> Heap a -> Maybe (Int, a)
leftChild index heap = do
  let
    newIndex = 2 * index + 1
  mValue <- heap ^? ix newIndex
  pure (newIndex, mValue)

heapDelete :: Ord a => Int -> Heap a -> Heap a
heapDelete _ mempty = mempty
heapDelete parentIndex heap@(Heap vec)
  = fromMaybe heap $ do
    case (leftChild parentIndex heap, rightChild parentIndex heap) of
      (Nothing, Nothing) ->
        pure mempty

      (Nothing, Just (childIndex, rChild)) ->
        processChild parentIndex childIndex rChild vec

      (Just (childIndex, lChild), Nothing) ->
        processChild parentIndex childIndex lChild vec

      (Just (leftChildIndex, lChild), Just (rightChildIndex, rChild)) ->
        bool (processChild parentIndex leftChildIndex lChild vec) (processChild parentIndex rightChildIndex rChild vec)
          $ lChild > rChild
  where
    processChild parentIndex childIndex child vec
      = pure $ heapDelete childIndex (Heap $ vec & parentIndex .~ child)

heapPop :: Ord a => Heap a -> Maybe (a, Heap a)
heapPop (Heap []) = Nothing
heapPop (Heap (x :< xs)) = do

  -- Just (x,) <*> heapDelete 1 (Heap xs)

{-

0 - 1 2
1 - 3 4
2 - 5 6
3 - 7 8
4 - 9 10

-}


bubbleUp :: Ord a => Heap a -> Heap a
bubbleUp = undefined

bubbleDown :: Ord a => Int -> Heap a -> Maybe(Heap a)
bubbleDown = undefined


instance Functor Heap where
  fmap f (Heap struct) = Heap $ f <$> struct

instance Ord a => Semigroup (Heap a) where
  Heap a <> Heap [] = Heap a
  Heap a <> Heap (b :< bs) = heapPush b (Heap a) <> Heap bs

instance Ord a => Monoid (Heap a) where
  mempty = Heap []

instance PriorityQueue Heap where
  pqPush = heapPush
  pqPop = heapPop
