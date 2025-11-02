the project contains:

1. frontend with react or vite js - here users/provers will make guess and proof will be generated out of their guess.then they submit it.

in the code we generate a proof.

noir-js for frontend and noir for creating circuit.

Barritenberg CLi has a barritenberg-js as well for frontend.
ultra honk backend.

2. actual circuit logic with noir - we will check if the hash of the answer matches the hash of the guess.

3. smart contracts required to verify proof onchain since we are also minting the nfts here.

we cant make guesses if we already won once.