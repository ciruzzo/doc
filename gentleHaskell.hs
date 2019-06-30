-- working code for Resource monad in Section 9.3 of
  -- https://www.haskell.org/tutorial/monads.html

-- https://stackoverflow.com/questions/31652475/defining-a-new-monad-in-haskell-raises-no-instance-for-applicative
--
import Control.Applicative -- Otherwise you can't do the Applicative instance.
import Control.Monad (liftM, ap)

type Resource           =  Integer

data R a = R (Resource -> (Resource, Either a (R a)))

instance Monad R where
  R c1 >>= fc2          = R (\r -> case c1 r of
                                (r', Left v)    -> let R c2 = fc2 v in
                                                     c2 r'
                                (r', Right pc1) -> (r', Right (pc1 >>= fc2)))
  return v              = R (\r -> (r, (Left v)))


instance Functor R where
  fmap = liftM

instance Applicative R where
  pure  = return
  (<*>) = ap

step                    :: a -> R a
step v                  =  c where
                              c = R (\r -> if r /= 0 then (r-1, Left v)
                                                     else (r, Right c))
inc                     :: R Integer -> R Integer
inc i                   =  do iValue <- i
                              step (iValue+1)

lift1                   :: (a -> b) -> (R a -> R b)
lift1 f                 =  \ra1 -> do a1 <- ra1
                                      step (f a1)



lift2                   :: (a -> b -> c) -> (R a -> R b -> R c)
lift2 f                 =  \ra1 ra2 -> do a1 <- ra1
                                          a2 <- ra2
                                          step (f a1 a2)

(==*)                   :: Ord a => R a -> R a -> R Bool
(==*)                   =  lift2 (==)

instance Num a => Num (R a) where
  (+)                   =  lift2 (+)
  (-)                   =  lift2 (-)
  negate                =  lift1 negate
  (*)                   =  lift2 (*)
    abs                   =  lift1 abs
  fromInteger           =  return . fromInteger
  signum                =  lift1 signum

--inc'                     :: R Integer -> R Integer
--inc' i                   =  lift1 (i+1)

inc''                     :: R Integer -> R Integer
inc'' x                   =  x + 1


ifR                     :: R Bool -> R a -> R a -> R a
ifR tst thn els         =  do t <- tst
                              if t then thn else els

fact                    :: R Integer -> R Integer
fact x                  =  ifR (x ==* 0) 1 (x * fact (x-1))

run                     :: Resource -> R a -> Maybe a
run s (R p)             =  case (p s) of
                             (_, Left v) -> Just v
                             _           -> Nothing
                             
