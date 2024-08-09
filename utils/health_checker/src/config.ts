export const L1_RPC_ENDPOINT = process.env.L1_RPC_ENDPOINT || "";
export const L2_RPC_ENDPOINT = process.env.L2_RPC_ENDPOINT || "";
export const L2_EXPLORER_URL = process.env.L2_EXPLORER_URL || "";

export const COMMIT_OPERATOR_ADDRESS = process.env.COMMIT_OPERATOR_ADDRESS || "";
export const COMMIT_OPERATOR_PK = process.env.COMMIT_OPERATOR_PK || "";

export const BLOBS_OPERATOR_ADDRESS = process.env.BLOBS_OPERATOR_ADDRESS || "";
export const BLOBS_OPERATOR_PK = process.env.BLOBS_OPERATOR_PK || "";

export const SENDER_ADDRESS = process.env.SENDER_ADDRESS || "";
export const SENDER_PK = process.env.SENDER_PK || "";

export const SLACK_HOOK_URL = process.env.SLACK_HOOK_URL || "";

// String to number conversion
export const WAITING_COMMIT_HASH_TIME_IN_MS = 60 * 1000; 
export const WAITING_PROVE_HASH_TIME_IN_MS_WITH_PROVER_IN_MS = 4 * 60 * 60 * 1000; 
export const WAITING_PROVE_HASH_TIME_IN_MS_WITHOUT_PROVER_IN_MS =  1 * 60 * 1000; 
export const WAITING_EXECUTED_HASH_TIME_IN_MS = 60 * 1000; 

export const ETH_SENDER_SENDER_PROOF_SENDING_MODE = process.env.ETH_SENDER_SENDER_PROOF_SENDING_MODE || "SkipEveryProof";

export const DAILY_OPERATOR_BALANCE_CHECK_INTERVAL = process.env.DAILY_OPERATOR_BALANCE_CHECK_INTERVAL || ""
export const OPERATOR_BALANCE_THRESHOLD_CHECK_INTERVAL = process.env.OPERATOR_BALANCE_THRESHOLD_CHECK_INTERVAL || ""; 
export const ADVANCE_BLOCKCHAIN_CHECK_INTERVAL = process.env.ADVANCE_BLOCKCHAIN_CHECK_INTERVAL || ""; 

export const THRESHOLDS = [0, 0.5, 1];
