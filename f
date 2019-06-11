#!/bin/bash

set -x

ACT="${1:-create}"
CMD="${2:-kubectl}"
ERRORS="${ERRORS:-t}"

if [ -z "${ERRORS}" ]; then
    set -e
fi

# Create the namespaces for the HCO
${CMD} create ns kubevirt-hyperconverged
${CMD} ${ACT} ns node-maintenance-operator

# Switch to the HCO namespace.
${CMD} config set-context $(${CMD} config current-context) --namespace=kubevirt-hyperconverged

# Launch all of the CRDs.
${CMD} ${ACT} -f https://raw.githubusercontent.com/kubevirt/hyperconverged-cluster-operator/master/deploy/converged/crds/hco.crd.yaml
${CMD} ${ACT} -f https://raw.githubusercontent.com/kubevirt/hyperconverged-cluster-operator/master/deploy/converged/crds/kubevirt.crd.yaml
${CMD} ${ACT} -f https://raw.githubusercontent.com/kubevirt/hyperconverged-cluster-operator/master/deploy/converged/crds/cdi.crd.yaml
${CMD} ${ACT} -f https://raw.githubusercontent.com/kubevirt/hyperconverged-cluster-operator/master/deploy/converged/crds/cna.crd.yaml
${CMD} ${ACT} -f https://raw.githubusercontent.com/kubevirt/hyperconverged-cluster-operator/master/deploy/converged/crds/ssp.crd.yaml
${CMD} ${ACT} -f https://raw.githubusercontent.com/kubevirt/hyperconverged-cluster-operator/master/deploy/converged/crds/kwebui.crd.yaml
${CMD} ${ACT} -f https://raw.githubusercontent.com/kubevirt/hyperconverged-cluster-operator/master/deploy/converged/crds/nodemaintenance.crd.yaml

# Launch all of the Service Accounts, Cluster Role(Binding)s, and Operators.
${CMD} ${ACT} -f https://raw.githubusercontent.com/kubevirt/hyperconverged-cluster-operator/master/deploy/converged/cluster_role.yaml
${CMD} ${ACT} -f https://raw.githubusercontent.com/kubevirt/hyperconverged-cluster-operator/master/deploy/converged/service_account.yaml
${CMD} ${ACT} -f https://raw.githubusercontent.com/kubevirt/hyperconverged-cluster-operator/master/deploy/converged/cluster_role_binding.yaml
${CMD} ${ACT} -f https://raw.githubusercontent.com/kubevirt/hyperconverged-cluster-operator/master/deploy/converged/operator.yaml

# Create an HCO CustomResource, which creates the KubeVirt CR, launching KubeVirt.
${CMD} ${ACT} -f https://raw.githubusercontent.com/kubevirt/hyperconverged-cluster-operator/master/deploy/converged/crds/hco.cr.yaml
