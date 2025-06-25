FROM alpine:latest

# Step 1: Show current state
RUN pwd && ls && whoami

# Step 2: Install necessary packages
RUN echo "[Step] Installing packages..." && \
    apk add --no-cache logrotate busybox-suid dos2unix file

# Step 3: Set working directory for logrotate configs
WORKDIR /etc/logrotate.d

# Step 4: Copy cron job script and config files
COPY ./logrotate-cron /etc/periodic/daliy/logrotate-cron
COPY ./*.conf /etc/logrotate.d/

# Step 6: Convert line endings and verify
RUN echo "[Step] Converting line endings..." && \
    dos2unix /etc/logrotate.d/*.conf && \
    echo "[Step] Verifying line endings..." && \
    file /etc/logrotate.d/*.conf && \
    echo "[Step] Line ending conversion complete."

# Step 7: Fix file permissions
RUN echo "[Step] Fixing permissions..." && \
    chmod 644 /etc/logrotate.d/*.conf && \
    chmod +x /etc/periodic/daily/logrotate-cron

RUN ls -l /etc/logrotate.d/ && \
    ls -l /etc/periodic/daily/ && \
    echo "[Step] Final user:" && whoami && \
    echo "[Step] Final working directory:" && pwd && \
    echo "[Step] Setup complete."


# Step 8: Final check
RUN sh -c 'echo "[Step] Final user:" && whoami && echo "[Step] Final working directory:" && pwd && echo "[Step] Setup complete."'

# Step 9: Start cron in foreground with debug mode
# Alpine’s crond looks in /etc/periodic/*/ (like hourly, daily, weekly, etc.).
CMD ["crond", "-f", "-d", "8"]
