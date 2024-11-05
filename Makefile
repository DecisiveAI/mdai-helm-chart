CHART_PATH = Chart.yaml
BACKUP_PATH = $(CHART_PATH).backup

# Ensure yq is installed
YQ_CHECK := $(shell command -v yq)

.PHONY: check-yq
check-yq:
ifndef YQ_CHECK
	$(error "yq is not installed. Please install yq to proceed.")
endif

.PHONY: backup
backup:
	@if [ ! -f "$(BACKUP_PATH)" ]; then \
		cp "$(CHART_PATH)" "$(BACKUP_PATH)"; \
		echo "Backup created at $(BACKUP_PATH)"; \
	else \
		echo "Backup already exists"; \
	fi

.PHONY: modify
modify: check-yq backup
	@if [ -z "$(CHART_NAME)" ] || [ -z "$(NEW_REPO)" ]; then \
		echo "Error: CHART_NAME and NEW_REPO arguments are required"; \
		exit 1; \
	fi
	@yq e -i "(.dependencies[] | select(.name == \"$(CHART_NAME)\")).repository = \"$(NEW_REPO)\"" "$(CHART_PATH)"
	@echo "$(CHART_PATH) has been modified with new repository for $(CHART_NAME): $(NEW_REPO)"

	# Update version if provided
	@if [ -n "$(VERSION)" ]; then \
		yq e -i "(.dependencies[] | select(.name == \"$(CHART_NAME)\")).version = \"$(VERSION)\"" "$(CHART_PATH)"; \
		echo "$(CHART_PATH) has been modified with new version for $(CHART_NAME): $(VERSION)"; \
	fi
	helm dep update

.PHONY: restore
restore:
	@if [ -f "$(BACKUP_PATH)" ]; then \
		mv "$(BACKUP_PATH)" "$(CHART_PATH)"; \
		echo "$(CHART_PATH) has been restored from $(BACKUP_PATH)"; \
		helm dep update; \
	else \
		echo "Backup not found. Cannot restore"; \
	fi
