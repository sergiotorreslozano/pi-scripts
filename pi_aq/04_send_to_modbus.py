from pymodbus.client.tcp import ModbusTcpClient
from aq import AQ
import sys
import datetime


def read_value(sensor_type):
    global response
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"{timestamp} Reading:  {sensor_type}")
    aq = AQ()
    if sensor_type == "temp":
        response = int(aq.get_temp())
    elif sensor_type == "co2":
        response = int(aq.get_eco2())
    else:
        print("Error: Invalid operation")
        return None
    print(f"{timestamp} Read: {response}")
    return response


def send_integer_to_modbus_server(server_address, port, registry, value):
    
    port = int(port)
    # Create a Modbus TCP client
    modbus_client = ModbusTcpClient(server_address, "socket", port)

    try:
        # Connect to the Modbus server
        if modbus_client.connect():
            # Send an integer value to a specific Modbus register (address 0 in this example)
            # You can change the register address based on your Modbus server configuration
            modbus_client.write_register(registry, value=value, slave=1)
            timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            print(f"{timestamp} Sent value {value} to Modbus server at {server_address}:{port} in registry {registry}")
        else:
            print("Failed to connect to Modbus server.")

    except Exception as e:
        print(f"Error: {e}")

    finally:
        # Close the Modbus TCP connection
        modbus_client.close()


if __name__ == "__main__":
    if len(sys.argv) != 5:
        print("Usage: python3 send_to_modbus.py <server_address> <port> <registry> <sensor_type>")
        sys.exit(1)

    server_address = sys.argv[1]
    port = sys.argv[2]
    registry = int(sys.argv[3])
    sensor_type = sys.argv[4]
    
    result = read_value(sensor_type)
    send_integer_to_modbus_server(server_address , port, registry, result)


