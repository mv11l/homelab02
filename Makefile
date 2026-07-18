TOFU := $(shell command -v tofu 2>/dev/null)
TF   := $(shell command -v terraform 2>/dev/null)

ifdef TOFU
  TF_BIN := tofu
else ifdef TF
  TF_BIN := terraform
else
  $(error Neither 'tofu' nor 'terraform' found in PATH)
endif

DIR := tofu

.PHONY: init plan apply talos-inspect

init:
	$(TF_BIN) -chdir=$(DIR) init

plan:
	$(TF_BIN) -chdir=$(DIR) plan

apply:
	$(TF_BIN) -chdir=$(DIR) apply -auto-approve
	$(MAKE) talos-inspect

talos-inspect:
	@if ! command -v talosctl >/dev/null 2>&1; then \
		echo "talosctl is not installed. Install it from:"; \
		echo "  https://docs.siderolabs.com/talos/v1.13/getting-started/talosctl"; \
		exit 1; \
	fi
	@VM_IP=$$($(TF_BIN) -chdir=$(DIR) output -raw public_ip); \
	echo "VM_IP=$$VM_IP"; \
	talosctl -n $$VM_IP version --insecure; \
	talosctl -n $$VM_IP get disks --insecure; \
	talosctl -n $$VM_IP get links --insecure
