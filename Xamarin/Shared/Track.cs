using System;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Collections.Generic;

namespace Xamarin.Shared
{
	public class Track
	{
		public String name;

		public Gate[] gates;
		public int id;
		public Gate start;

		private Track(JToken json) {
			var jsonGates = (JArray)json["gates"];
			var gateList = new List<Gate>();
			for (int i = 0; i < jsonGates.Count; i++) {
				var jsonGate = (JObject)jsonGates[i];
				var gate = new Gate((Gate.Type)Enum.Parse(typeof(Gate.Type), (string)jsonGate["gate_type"], true), 
					(int)jsonGate["split_number"],
					(double)jsonGate["latitude"],
					(double)jsonGate["longitude"],
					(double)jsonGate["bearing"]);
				if (gate.type == Gate.Type.START_FINISH || gate.type == Gate.Type.START) {
					start = gate;
				}
				gateList.Add(gate);
			}
			id   = (int)json["id"];
			name = (string)json["name"];
			gates = gateList.ToArray();
		}

		public static Track[] Load(String json) {
			try {
				if (json.StartsWith("[")) {
					var jsonArray = Newtonsoft.Json.Linq.JArray.Parse(json);
					var array = new Track[jsonArray.Count];
					for (int i = 0; i < jsonArray.Count; i++) {	
						array[i] = new Track(jsonArray[i]["track"]);
					}
					return array;
				} else {
					return new Track[] { new Track(Newtonsoft.Json.Linq.JObject.Parse(json)["track"]) };
				}
			} catch (System.ArgumentNullException e) {
				Console.WriteLine("Track load error: " + e);
			}
			return null;
		}

		public int NumSplits() {
			return gates.Length;
		}
	}
}

