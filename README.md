# Cryptocaml + Crowdfunding app

This repository consists of two projects: cryptocaml and a crypto crowdfunding app

## Cryptocaml

### Summary

Cryptocaml is an OCaml library that interfaces with the Ethereum and Polygon blockchains.
Cryptocaml can...

<ul>
  <li> Import smart contracts </li>
  <li> Execute smart contract functions </li>
  <li> Send raw ETH transactions </li>
  <li> Send transfer ETH transactions </li>
  <li> Read on-chain wallet balances </li>
  <!-- <li> Read on-chain contract states </li> -->
</ul>

...all in OCaml!

## Crowdfunding app

### Summary

The crowdfunding app is the first use of cryptocaml to create a
real-world application.

Users can create crowdfunding projects and request for a certain
amount of funds to be raised.

Other users can donate to projects by connecting their crypto
wallets and choosing a project to fund.

Once the target amount is raised, a donor-wide poll is conducted to
determine finally whether to release the funds or not.

If 75% of donors vote yes, the funds are released!

If this consensus cannot be reached, the funds are returned to donors.

I haven't planned the structure of this app yet because it depends on
how the cryptocaml library is made. However, for the basic structure,
I am thinking of making it just a backend API that utilizes cryptocaml.

## Libraries

<ul>
  <li>yojson</li>
  <li>cryptokit</li>
  <li>lwt</li>
</ul>

## Order of Implementation

I plan to implement the cryptocaml library first and then the crowdfunding app.
