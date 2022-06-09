Param(
  [parameter(mandatory=$true)][string]$flowName
)

Start-Process -FilePath "ms-powerautomate://"

Add-Type -AssemblyName "UIAutomationClient"
Add-Type -AssemblyName "UIAutomationTypes"
$uiAuto = [System.Windows.Automation.AutomationElement]
$pcdn = [System.Windows.Automation.PropertyCondition]
$acdn = [System.Windows.Automation.AndCondition]
$tree = [System.Windows.Automation.TreeScope]
$iptn = [System.Windows.Automation.InvokePattern]::Pattern
$wptn = [System.Windows.Automation.WindowPattern]::Pattern
$icptn = [System.Windows.Automation.ItemContainerPattern]::Pattern
$siptn = [System.Windows.Automation.ScrollItemPattern]::Pattern
$selptn = [System.Windows.Automation.SelectionItemPattern]::Pattern
$root = $uiAuto::RootElement

$cndPadWindowId = New-Object $pcdn($uiAuto::AutomationIdProperty, "ConsoleMainWindow")
$cndPadWindowClassName = New-Object $pcdn($uiAuto::ClassNameProperty, "WinAutomationWindow")
$cndPadWindow = New-Object $acdn($cndPadWindowId, $cndPadWindowClassName)
do{
  Start-Sleep -m 200
  $elmPadWindow = $root.FindFirst($tree::Children, $cndPadWindow)
}while($elmPadWindow -eq $null)

$cndTab = New-Object $pcdn($uiAuto::AutomationIdProperty, "ProcessesTabControl")
$elmTab = $elmPadWindow.FindFirst($tree::Subtree, $cndTab)

if($elmTab -ne $null){
  $cndTabItem = New-Object $pcdn($uiAuto::AutomationIdProperty, "MyFlowsTab")
  $elmTabItem = $elmTab.FindFirst($tree::Children, $cndTabItem)
  if($elmTabItem -ne $null){
    $selTabItem = $elmTabItem.GetCurrentPattern($selptn)
    $selTabItem.Select()
  }
}

if($elmPadWindow -ne $null){
  $cndDataGrid = New-Object $pcdn($uiAuto::AutomationIdProperty, "MyFlowsListGrid")
  $elmDataGrid = $elmPadWindow.FindFirst($tree::Subtree, $cndDataGrid)
}

if($elmDataGrid -ne $null){
  $icDataGrid = $elmDataGrid.GetCurrentPattern($icptn)
  $elmDataItem = $icDataGrid.FindItemByProperty($null, $uiAuto::NameProperty, $flowName)
  if($elmDataItem -ne $null){
    $siDataItem = $elmDataItem.GetCurrentPattern($siptn)
    $siDataItem.ScrollIntoView()
    $selDataItem = $elmDataItem.GetCurrentPattern($selptn)
    $selDataItem.Select()
  }
}

if($elmDataItem -ne $null){
  $cndStartButton = New-Object $pcdn($uiAuto::AutomationIdProperty, "StartFlowButton")
  $elmStartButton = $elmDataItem.FindFirst($tree::Subtree, $cndStartButton)
  if($elmStartButton -ne $null){
    $ivkStartButton = $elmStartButton.GetCurrentPattern($iptn)
    $ivkStartButton.Invoke()
  }
}

if($elmStartButton -ne $null){
  do{
    Start-Sleep -s 3
  }while($elmStartButton.GetCurrentPropertyValue($uiAuto::IsEnabledProperty) -eq $false)
}

$winPadWindow = $elmPadWindow.GetCurrentPattern($wptn)
$winPadWindow.Close()

#Reference information
#https://gist.github.com/kinuasa/0f5320786acd536aa161e1d2950267ce#file-startpadflow-ps1
