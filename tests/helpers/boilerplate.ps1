Import-Module helpers/common-helpers -ErrorAction SilentlyContinue
Import-Module helpers/licensed-helpers -ErrorAction SilentlyContinue
# Remove any existing Should:Because defaults
$PSDefaultParameterValues.Remove('Should:Because')
# Add our own Should:Because default. This scriptblock will expand to the value in $Output.String so we don't need it on every Should call.
$PSDefaultParameterValues.Add('Should:Because', { $Output.String })
