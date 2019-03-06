# WpfBase
Basic core library for WPF application with the mvvm pattern

This project is a fork of [MunkiWinchesters WpfUtility](https://github.com/MunkiWinchester/WpfUtility) which contains only the basic classes for a wpf mvvm project.
If you need more functions take a look at the project of munki!

The Project is available via [NuGet](https://www.nuget.org/packages/ZimLabs.WpfBase/):
```powershell
PM> Install-Package ZimLabs.WpfBase -Version 0.0.2
```

## Usage
### ObservableObject
The *ObservableObject* provides several funtions for a view model class like the *SetField* method.

```csharp
public class Person
{
    public string Name { get; set; }
    public DateTime Birthday { get; set; }
}

public class MainWindowViewModel : ObservableObject
{
    // SetField - Variante 1
    private string _name;

    public string Name
    {
        get => _name;
        set => SetField(_name, value);
    }

    // SetField - Variante 2
    private Person _person;

    public string PersonName
    {
        get => _person;
        set => SetField(_person, "Name", value);
    }

    private void FireOnPropertyChange()
    {
        var properties = GetProperties();

        foreach (var property in properties)
        {
            OnPropertyChanged(property);
        }
    }
}
```

### Command
With the *DelegateCommand* and the the *RelayCommand* you can bind a command from the view model to the view. 
The relay command provides the possibility to add parameters.

The xaml code
```xml
<Window
    xmlns:local="clr-namespace:Project.Ui">
    <Window.DataContext>
        <local:MainWindowViewModel />
    </Window.DataContext>
    <Grid>
        <Button 
            Content="Save"
            Command="{Binding SaveCommand}"
            CommandParameter="{x:Static local:SaveType.List}" />
        <Button
            Content="Load"
            Command="{Binding LoadCommand}">
    </Grid>
    
</Window>
```

The other code
```csharp
// SaveType-Class
public namespace Project.UI
{
    public enum SaveType
    {
        List,
        Entry
    }
}

// The view model
public namespace Project.UI
{
    public class MainWindowViewModel : ObservableObject
    {
        // Relay command with additional parameters
        public ICommand SaveCommand => new RelayCommand<SaveType>(Save);

        // Delegate command
        public ICommand LoadCommand => new DelegateCommand(LoadData);

        private void Save(SaveType type)
        {
            // ...
        }

        public void LoadData()
        {
            // ...
        }
    }
}
```
