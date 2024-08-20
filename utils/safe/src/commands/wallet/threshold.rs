use std::sync::Arc;

use clap::Parser;
use zksync_ethers_rs::{providers::Provider, types::Address};

use crate::contracts::safe::Safe;

#[derive(Parser, PartialEq)]
pub(crate) struct Args {
    #[clap(required = true, help = "The address of the Safe wallet.")]
    pub wallet_address: Address,
    #[arg(short = 'r', long = "rpc-url", help = "The RPC URL of the L1 network.", default_value = "https://rpc.sepolia.org")]
    pub l1_rpc_url: String,
}

pub(crate) async fn run(args: Args) -> eyre::Result<()> {
    let provider = Provider::try_from(args.l1_rpc_url)?;

    let safe = Safe::new(args.wallet_address, Arc::new(provider.clone()));
    let threshold = safe.get_threshold().await?;
    println!("Threshold: {threshold}");

    Ok(())
}
