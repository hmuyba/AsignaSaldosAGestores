# Proyecto Asignación de Saldos

Este proyecto en .NET realiza la asignación de saldos a gestores a partir de una tabla de saldos preexistente. Se utiliza SQL Server para gestionar las bases de datos y se integra con un procedimiento almacenado que realiza la asignación de manera equitativa.

## Descripción

El propósito de este proyecto es asignar saldos a un grupo de gestores de manera ordenada, asegurando que los saldos más altos sean asignados primero. El procedimiento almacenado en SQL Server se encarga de la asignación de saldos, mientras que la aplicación en .NET ejecuta el proceso y muestra los resultados en la consola.

### Funcionalidades

- Crear las tablas necesarias si no existen: `Saldos`, `Gestores`, `SaldosAsignados`.
- Insertar saldos y gestores de ejemplo.
- Ejecutar el procedimiento almacenado `AsignarSaldosAGestores`, el cual asigna saldos a gestores.
- Mostrar el nombre del gestor y el monto asignado en la consola.

## Requisitos

### Herramientas necesarias

- [SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)
- [.NET SDK](https://dotnet.microsoft.com/download)

### Paquetes NuGet requeridos

1. **System.Data.SqlClient**: Este paquete es necesario para conectar y trabajar con bases de datos SQL Server en tu proyecto .NET.

   Para instalarlo, ejecuta el siguiente comando en la terminal dentro del directorio del proyecto:

   ```bash
   dotnet add package System.Data.SqlClient
   ```

### Base de datos

1. Crea una base de datos llamada `AsignaSaldosDb` en tu instancia de SQL Server.

### Configuración de la conexión

En el archivo `Program.cs`, asegúrate de que la cadena de conexión sea correcta y apunte a tu servidor de base de datos:

```csharp
string connectionString = "Server=LAPTOP-CEE7AMA9\\SQLEXPRESS;Database=AsignaSaldosDb;Integrated Security=True;";
```

Cambia `LAPTOP-CEE7AMA9\\SQLEXPRESS` por el nombre de tu servidor SQL si es necesario.

## Estructura del Proyecto

```
/Proyecto
│
├── /sql
│   └── AsignarSaldos.sql   # Script SQL para crear las tablas y asignar saldos
│
├── /Program.cs             # Código en C# que ejecuta el procedimiento almacenado
└── README.md               # Documentación del proyecto
```

### `AsignarSaldos.sql`

Este script SQL crea las siguientes tablas si no existen:

- **Saldos**: Almacena los saldos que se asignarán a los gestores.
- **Gestores**: Contiene los gestores a los cuales se asignarán los saldos.
- **SaldosAsignados**: Registra los saldos asignados a cada gestor.

Además, el script crea o modifica el procedimiento almacenado `AsignarSaldosAGestores`, que realiza la asignación de saldos a los gestores.

### `Program.cs`

Este archivo contiene el código en C# que se conecta a la base de datos y ejecuta el procedimiento almacenado. Los resultados de la asignación se imprimen en la consola.

## Instrucciones para Ejecutar el Proyecto

1. **Configurar la base de datos**:
    - Ejecuta el script `AsignarSaldos.sql` en tu base de datos de SQL Server para crear las tablas y el procedimiento almacenado.
   
2. **Configurar la cadena de conexión**:
    - Asegúrate de que la cadena de conexión en el archivo `Program.cs` sea correcta.

3. **Ejecutar el proyecto**:
    - Abre una terminal en la carpeta raíz del proyecto y ejecuta el siguiente comando:

    ```bash
    dotnet run
    ```

4. **Ver resultados**:
    - El programa ejecutará el procedimiento almacenado y mostrará los gestores junto con los saldos asignados en la consola.

## Ejemplo de Salida

Al ejecutar el programa, la consola mostrará algo similar a esto:

```
Gestor            Monto
-----             -----
Gestor1           $4,927.00
Gestor1           $4,130.00
Gestor1           $3,352.00
Gestor1           $2,389.00
Gestor1           $1,900.00
Gestor2           $4,900.00
Gestor2           $4,120.00
Gestor2           $3,315.00
Gestor2           $2,355.00
Gestor2           $1,784.00
...
```

## Detalles del Procedimiento Almacenado

El procedimiento almacenado `AsignarSaldosAGestores` realiza lo siguiente:

1. **Calcula el número de iteraciones necesarias**: Divide los saldos entre los gestores y calcula cuántas veces debe recorrer el conjunto de saldos.
2. **Ordena los saldos de mayor a menor**: Los saldos se asignan en orden descendente.
3. **Asigna saldos a los gestores**: Utiliza un cursor para recorrer los gestores y asignarles saldos de manera equitativa.
4. **Muestra los saldos asignados**: Devuelve el nombre del gestor y el monto asignado.

