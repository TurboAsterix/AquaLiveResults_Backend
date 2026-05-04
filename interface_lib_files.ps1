function Initialize_Output_File {
    param(
        [string] $file
    )

    <# Initialize output file #>
    If (Test-Path $file)
    {
        Remove-Item $file
    }
}