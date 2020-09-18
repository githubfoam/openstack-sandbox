IMAGE := alpine/fio
APP:="scripts/archlinux-req.sh"

deploy-boxes:
	bash scripts/deploy-boxes.sh

deploy-libvirt:
	bash scripts/deploy-libvirt.sh

deploy-vagrant:
	bash scripts/deploy-vagrant.sh

push-image:
	docker push $(IMAGE)

.PHONY: deploy-boxes deploy-libvirt deploy-vagrant push-image
