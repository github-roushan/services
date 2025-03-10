-- All auctions for which a valid solver competition exists. 
CREATE TABLE competition_auctions (
   id bigint PRIMARY KEY,
   -- The block number at which the auction was created
   block bigint NOT NULL,
   -- The block number until which all winning solutions from a competition should be settled on-chain
   deadline bigint NOT NULL,
   -- Orders that were part of the auction
   order_uids bytea[] NOT NULL,
   -- The auction's native price tokens
   price_tokens bytea[] NOT NULL,
   -- The auction's price values
   price_values numeric(78,0)[] NOT NULL,
   -- A list of all surplus capturing JIT order owners that were part of the auction
   surplus_capturing_jit_order_owners bytea[] NOT NULL
);

-- Table to store all proposed solutions for an auction, received from solvers during competition time.
-- A single auction can have multiple solutions, and each solution can contain multiple order executions.
-- This design allows for multiple solutions from a single solver
CREATE TABLE proposed_solutions (
   auction_id bigint NOT NULL,
   -- Unique Id of the solution within the auction (generated by the autopilot)
   uid bigint NOT NULL,
   -- The solution id that the solver assigned to the solution
   id bigint NOT NULL,
   -- solver submission address
   solver bytea NOT NULL,
   -- Whether the solution is one of the winning solutions of the auction
   is_winner boolean NOT NULL,
   -- The score of the solution
   score numeric(78,0) NOT NULL,
   -- UCP price tokens
   price_tokens bytea[] NOT NULL,
   -- UCP price values
   price_values numeric(78,0)[] NOT NULL,

   PRIMARY KEY (auction_id, uid)
);

-- Table to store all order executions of a solution
CREATE TABLE proposed_trade_executions (
   auction_id bigint NOT NULL,
   solution_uid bigint NOT NULL,
   order_uid bytea NOT NULL,
   -- The effective amount that left the user's wallet including all fees.
   executed_sell numeric(78,0) NOT NULL,
   -- The effective amount the user received after all fees.
   executed_buy numeric(78,0) NOT NULL,

   PRIMARY KEY (auction_id, solution_uid, order_uid)
);

-- Jit orders that were proposed by solvers during competition time, but not yet potentially executed
CREATE TABLE proposed_jit_orders (
   auction_id bigint NOT NULL,
   solution_uid bigint NOT NULL,
   order_uid bytea NOT NULL,
   sell_token bytea NOT NULL,
   buy_token bytea NOT NULL,
   limit_sell numeric(78,0) NOT NULL,
   limit_buy numeric(78,0) NOT NULL,
   side OrderKind NOT NULL,

   PRIMARY KEY (auction_id, solution_uid, order_uid)
);
