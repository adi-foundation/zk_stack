# Health Checker

This project is a health checker script that periodically checks the balance of specific Ethereum addresses and sends notifications via Slack if there are changes. It uses `bun` for dependency management and `systemd` for service management.

## Project Structure

- **./src/health_checker.ts**: The main script for executing the jobs.
- **./src/slack.ts**: Contains all Slack related methods.
- **./src/l1_rpc.ts**: Contains all methods involved with calling the L1 RPC.
- **./src/utils.ts**: Utilities for the repository.
- **./src/jobs/**: Directory containing different job logic.
- **./src/config.ts**: Contains the environment variables.
- **./models/**: Directory containing classes and predefined log messages.
- **./Makefile**: Makefile for managing the project.
- **./health_checker.service**: Service configuration file.
- **./.env-example**: Example environment variables file.
- **./.env**: Environment variables file (not tracked by version control).
- **./package.json**: Project metadata and dependencies.
- **./package-lock.json**: Locked versions of dependencies.
- **./bun.lockb**: Lock file for Bun package manager.
- **./README.md**: Project documentation.
- **./.gitignore**: Git ignore file.

## Prerequisites

- [bun](https://bun.sh) must be installed on your system.
- Node.js and npm should be installed.

- [.env] Copy the .env-example file into .env and add the proper information before next step

## Installation and use

1. **Install Dependencies:**

    Use the Makefile to install the dependencies:

    ```sh
    make deps
    ```

2. **Install and Enable the Service:**

    ```sh
    make install
    ```

3. **Start the Service:**

    ```sh
    make start
    ```

4. **Check Service Logs:**

    ```sh
    make print
    ```

## Adding a New Job

To add a new job to the health checker:

1. **Create the job file:**
   - Create a new file inside the `src/jobs` directory with the logic of your job.
   
2. **Register the job:**
   - Add the method to the `src/health_checker.ts` script.

### Example

1. Create a new job file, e.g., `src/jobs/new_job.ts`:
    ```typescript
    export async function newJob() {
        // Your job logic here
    }
    ```

2. Import and register the job in `src/health_checker.ts`:
    ```typescript
    import { newJob } from './jobs/new_job';

    async function main() {
        new CronJob('0 0 * * *', () => {
            newJob().catch(console.error);
        }).start();
    }
    ```

## Makefile Targets

- `deps`: Installs project dependencies using `bun`.
- `install`: Installs and enables the `health_checker` service.
- `start`: Starts the `health_checker` service.
- `stop`: Stops the `health_checker` service.
- `print`: Prints the logs of the `health_checker` service.
- `reload`: Reloads the systemd manager configuration.
- `restart`: Restarts the `health_checker` service.
- `uninstall`: Stops, disables, and removes the `health_checker` service.
