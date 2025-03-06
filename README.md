# Backup PostgreSQL Database

This repository contains a simple shell script (`backup.sh`) to back up your PostgreSQL database. Follow the instructions below to get started.

---

## Prerequisites

- A running PostgreSQL server.
- Bash shell (or compatible terminal).
- Basic knowledge of environment variables and command-line operations.

---

## Setup

1. **Clone the Repository**

   Clone this repository to your server or local machine.

   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Configure Environment Variables**

   Copy the example environment file and update it with your settings:

   ```bash
   cp .env.example .env
   ```

   Open the `.env` file and fill in the required values:

   ```bash
   # PostgreSQL Server Configuration
   DB_HOST=#########         # The hostname or IP address of your PostgreSQL server.
   DB_USER=########          # Your PostgreSQL username.
   DB_PASSWORD=############  # Your PostgreSQL password (keep it secure!).
   DB_PORT=####              # PostgreSQL port number (default is 5432).

   # Application & Backup Configuration
   BACKEND_FULL_PATH=#################################################################  # Absolute path to your backend directory.
   BACKUPS_FOLDER_NAME=#######        # Folder where backup files will be stored.
   ```

3. **Make the Script Executable**

   Ensure the backup script has executable permissions:

   ```bash
   chmod +x backup.sh
   ```

---

## Usage

Run the backup script and follow the prompt to enter the PostgreSQL database name to back up:

```bash
./backup.sh
```

And script asks "Enter Postgre DB name: " and you will need to enter the PostgreSQL DB name here.

The script will use the configuration defined in the `.env` file to perform the backup. The backup files will be stored in the directory specified by `BACKUPS_FOLDER_NAME`.

---

## Customization & Troubleshooting

- **Customization:**  
  Modify the `.env` file as needed to suit your environment. Ensure all paths and credentials are correct.

- **Troubleshooting:**  
  - Verify that your PostgreSQL server is running and accessible.
  - Double-check the `.env` file for typos or incorrect settings.
  - Check file permissions if the script fails to execute.

---

## Contributing

Contributions are welcome! Please fork the repository, make your changes, and submit a pull request with a detailed description of your modifications.

---

## License

This project is licensed under the terms specified in the LICENSE file.
```

This `README.md` provides a clear guide on setting up, configuring, and using the backup script, along with instructions for troubleshooting and contributing.
