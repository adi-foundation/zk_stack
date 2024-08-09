import { getBalanceL1, getBalanceL2 } from "../src/rpc";

export enum OperatorType {
    COMMIT = "COMMIT", 
    BLOBS = "BLOBS",
    TX_SENDER = "TX_SENDER",
};

export interface Threshold {
    low: number, 
    high: number
};


export enum ThresholdMovement {
    DECREASE,
    INCREASE, 
    CRITICAL, 
    NONE
}


export interface OperatorInterface {
    type: OperatorType;
    address: string;
    privateKey: string | null;
    threshold: Threshold;

    balanceL2(): Promise<number>;
    balanceL1(): Promise<number>;
};

export class Operator implements OperatorInterface {
    type: OperatorType;
    address: string;
    privateKey: string | null; 
    threshold: Threshold;

    constructor(type: OperatorType, address: string, private_key: string | null) {
        this.type = type;
        this.address = address;
        this.privateKey = private_key;
        this.threshold = {low: 0, high: 0};
    }
    
    async balanceL2(): Promise<number> {
        return await getBalanceL2(this.address);
    }

    async balanceL1(): Promise<number> {
        return await getBalanceL1(this.address);
    }
}
