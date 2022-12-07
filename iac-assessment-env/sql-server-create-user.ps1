#get parameters from the main.parameters used for the bicep
$mainParametersFile = get-content -raw -path "iac-assessment-env\main.parameters.json" | ConvertFrom-Json | Select-Object -ExpandProperty parameters

#assign variables values
$candidateID = $mainParametersFile.candidateID.value
$candidateAadObjectID = $mainParametersFile.candidateAadObjectID.value
$sqlDBName = $mainParametersFile.sqlDBName.value
$sqlServerName = $mainParametersFile.sqlServerName.value 
$administratorLogin = $mainParametersFile.administratorLogin.value
$administratorLoginPassword = $mainParametersFile.administratorLoginPassword.value

#set password
$candidateUniqueID = $candidateAadObjectID.Substring(0, 6)
$sqlLoginAccountPassword = "apiTest$candidateUniqueID"

$connectionString = "Server=tcp:$sqlServerName.database.windows.net,1433;Initial Catalog=$sqlDBName;User ID=$administratorLogin;Password=$administratorLoginPassword;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"

Write-Host $connectionString

#replace parameters in query
$queryPath = "iac-assessment-env\Resources\create-login.sql"
$query =[System.IO.File]::ReadAllText($queryPath)
$query = $query.Replace("REPLACE_WITH_CANDIDATE_ID", $candidateID)
$query = $query.Replace("REPLACE_WITH_CANDIDATE_ID", $candidateID)
$query = $query.Replace("REPLACE_WITH_PASSWORD", "'$sqlLoginAccountPassword'")

Write-Host $query

$connection = New-Object -TypeName System.Data.SqlClient.SqlConnection($connectionString)
$command = New-Object -TypeName System.Data.SqlClient.SqlCommand($query, $connection)

#execute query
$connection.Open()
$command.ExecuteNonQuery()
$connection.Close()




