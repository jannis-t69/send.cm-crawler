# send.cm-crawler

The script will parse the pasted send.cm folder and crawl the subfolders. It will generate a links.html file with all the subfolder links which then can be iported into JDownloader through select and copy

Instructions:
1. Install required utilities:
  - bash shell
  - curl
  - wget
2. Copy the script to a local shell folder
3. Make script executable with chmod +x <script-file-name>
4. execute script with ./<script-file-name>
5. Paste the send.cm URL to the commandline request
6. Start JDownloader, open the created links.html file in your browser, select all links and copy them into clipboard. JDownloader Observer should import the copied links from clipboard
