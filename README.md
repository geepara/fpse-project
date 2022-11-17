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

### Mock Use

Someone wants to create an NFT project using OCaml.

They write their NFT contract.

They develop an app with an OCaml frontend that needs
to interface with the contract.

As an example, maybe they want to allow users to mint
directly from the contract so their frontend app has
to be able to call functions on the contract.

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

### Mock use

A person wants to raise funds for a loved one who is in the hospital.
They need money to pay for surgery.

The person creates a fundraiser through a frontend that uses the
crowdcaml API. This creates a fundraising smart contract on the
backend that will receive the donations and enforce the voting
rules.

The frontend also has a page that can retrieve all of the available
projects for funding using the API. This way, donators can find the
specific fund.

Users can create wallets and by using their private key are able
to donate to the cause by sending ETH to the contract.

Once the contract is filled with the requested amount of funds,
each donor must vote to confirm the release of the funds. The votes
are verified by the contract which keeps track of the wallets that
have donated to the fund.

Once 75% of donors vote to release the funds, the original creator
of the fundraiser receives the funds from the contract in their
wallet.

If 3 days elapse and the vote hasn't reached 75%, all of the funds
are return to the donors.

## Libraries

<ul>
  <li>yojson</li>
  <li>cryptokit</li>
  <li>lwt</li>
</ul>

## Order of Implementation

I plan to implement the cryptocaml library first and then the crowdfunding app.
