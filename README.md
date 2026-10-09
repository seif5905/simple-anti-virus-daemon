# Antivirus and File Restore Tool

## 1. Overview

This project is a Bash-based antivirus tool for Ubuntu. It scans files for suspicious keywords and extensions, moves flagged files to a separate directory, and allows approved files to be restored and added to a whitelist.

### Folder Structure

```text
lab2/
├── antivirus-cron.sh
├── antivirusd.sh
├── restore.sh
├── dir/
├── malicious_dir/
├── whitelist.txt
├── directory-info.last
└── directory-info.new
```

- `antivirus-cron.sh`: Runs the scheduled scan.
- `antivirusd.sh`: Monitors the directory and scans files.
- `restore.sh`: Restores files from `malicious_dir` to `dir`.
- `dir/`: Directory being scanned.
- `malicious_dir/`: Stores flagged files.
- `whitelist.txt`: Stores approved files.
- `directory-info.last` and `directory-info.new`: Used to detect directory changes.

## 2. Prerequisites and Installation

The project requires Bash, `grep`, `diff`, and cron.

Install them on Ubuntu:

```bash
sudo apt update
sudo apt install bash grep diffutils cron
sudo systemctl enable --now cron
```

From the `lab2/` directory, make the scripts executable:

```bash
chmod +x antivirus-cron.sh antivirusd.sh restore.sh
```

Make sure `dir/` and `malicious_dir/` exist before running the tools.

## 3. Running the Tools

### Antivirus daemon

Run the daemon from the `lab2/` directory:

```bash
./antivirusd.sh dir malicious_dir
```

The daemon monitors `dir/`, checks files against the detection rules, and moves flagged files to `malicious_dir/`.

To check the results:

```bash
ls -la dir malicious_dir
```

Press `Ctrl+C` to stop a foreground daemon.

### Restoring files

Run:

```bash
./restore.sh
```

Follow the displayed options to select a file to restore. The file should return to `dir/`.

A restored file may be flagged again unless it is added to the whitelist.

## 4. Detection Rules

The detection rules are defined in `antivirusd.sh`.

**Flagged keywords:**

```bash
grep -Ei 'virus|trojan|malware|worm|ransomware'
```

The `-E` option allows matching multiple keywords, while `-i` ignores letter case.

**Flagged extensions:**

The Bash conditions check extensions such as:

- `.exe`
- `.bat`
- `.vbs`
- `.scr`

These checks are basic detection rules and may flag legitimate files.

## 5. Configuring the Cron Job

Cron runs commands automatically at scheduled times.

### Steps

1. Make sure cron is installed and running.
2. Find the absolute path to the project:

   ```bash
   pwd
   ```

3. Open your crontab:

   ```bash
   crontab -e
   ```

4. Add the following line to run the scan at **12:31 AM on the third Friday of every month**:

   ```cron
   31 0 15-21 * * [ "$(date +\%u)" -eq 5 ] && /home/user/lab2/antivirus-cron.sh
   ```

   Replace `/home/user/lab2` with your actual project path.

   The third Friday falls between the 15th and 21st. The command checks that the date is Friday before running the script. The percent sign must be escaped in a crontab command.

5. Save and exit. Verify the job with:

   ```bash
   crontab -l
   ```

To temporarily disable the job, add `#` at the beginning of its line. Remove it when you want to enable the job again.

**Note:** Make sure `antivirus-cron.sh` runs the scan using the correct paths and arguments.

## 6. Whitelist

The whitelist prevents approved files from being flagged repeatedly.

### Adding a file

1. Identify the file you want to allow.
2. If it is in `malicious_dir/`, restore it using `restore.sh`.
3. Add the file to `whitelist.txt` using the format expected by `antivirusd.sh`.
4. Run another scan to verify that it is skipped.

### How it works

During a scan, `antivirusd.sh` checks whether a file is whitelisted before applying the detection rules. If the file is on the whitelist, it is skipped. Otherwise, its contents and extension are checked, and it may be moved to `malicious_dir/`.

## 7. Notes

- Only scan files you have permission to access.
- Review flagged files before restoring or opening them.
- Test the daemon, restore tool, whitelist, and cron job before relying on them.
- This tool uses simple checks and is not a replacement for a full antivirus program.
