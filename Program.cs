using System;
using System.Data;
using System.Data.SqlClient;

class Program
{
    static void Main(string[] args)
    {
        string connectionString = "Server=LAPTOP-CEE7AMA9\\SQLEXPRESS;Database=AsignaSaldosDb;Integrated Security=True;";
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            try
            {
                connection.Open();

                using (SqlCommand command = new SqlCommand("AsignarSaldosAGestores", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        Console.WriteLine("{0,-15} {1,8}", "Gestor", "Monto");
                        Console.WriteLine("{0,-15} {1,8}", "-----", "-----");

                        while (reader.Read())
                        {
                            string nombreGestor = reader["NombreGestor"].ToString();
                            decimal monto = Convert.ToDecimal(reader["Monto"]);
                            Console.WriteLine("{0,-15} {1,10:C2}", nombreGestor, monto);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Ocurrió un error: {ex.Message}");
            }
        }

        Console.WriteLine("Presione cualquier tecla para salir...");
        Console.ReadKey();
    }
}
