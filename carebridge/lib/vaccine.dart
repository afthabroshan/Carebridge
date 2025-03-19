import 'package:flutter/material.dart';

class Vaccine extends StatefulWidget {
  const Vaccine({super.key});

  @override
  State<Vaccine> createState() => _VaccineState();
}

class _VaccineState extends State<Vaccine> {
  final List<Map<String, dynamic>> vaccineSchedule = [
    {
      "age": "At Birth",
      "vaccines": [
        {"name": "BCG (Bacillus Calmette-Guérin)", "given": false},
        {"name": "Hepatitis B (Birth Dose)", "given": false},
        {"name": "Oral Polio Vaccine (OPV-0)", "given": false}
      ]
    },
    {
      "age": "6 Weeks",
      "vaccines": [
        {
          "name": "DTP (Diphtheria, Tetanus, Pertussis) - 1st Dose",
          "given": false
        },
        {"name": "Hepatitis B - 2nd Dose", "given": false},
        {
          "name": "Haemophilus Influenzae Type B (Hib) - 1st Dose",
          "given": false
        },
        {"name": "Rotavirus Vaccine - 1st Dose", "given": false},
        {
          "name": "PCV (Pneumococcal Conjugate Vaccine) - 1st Dose",
          "given": false
        },
        {"name": "Oral Polio Vaccine (OPV-1)", "given": false}
      ]
    },
    {
      "age": "10 Weeks",
      "vaccines": [
        {"name": "DTP - 2nd Dose", "given": false},
        {"name": "Hepatitis B - 3rd Dose", "given": false},
        {"name": "Hib - 2nd Dose", "given": false},
        {"name": "Rotavirus Vaccine - 2nd Dose", "given": false},
        {"name": "PCV - 2nd Dose", "given": false},
        {"name": "Oral Polio Vaccine (OPV-2)", "given": false}
      ]
    },
    {
      "age": "14 Weeks",
      "vaccines": [
        {"name": "DTP - 3rd Dose", "given": false},
        {"name": "Hepatitis B - 4th Dose", "given": false},
        {"name": "Hib - 3rd Dose", "given": false},
        {"name": "Rotavirus Vaccine - 3rd Dose", "given": false},
        {"name": "PCV - 3rd Dose", "given": false},
        {"name": "Oral Polio Vaccine (OPV-3)", "given": false}
      ]
    },
    {
      "age": "6 Months",
      "vaccines": [
        {"name": "Influenza Vaccine - 1st Dose", "given": false}
      ]
    },
    {
      "age": "7 Months",
      "vaccines": [
        {"name": "Influenza Vaccine - 2nd Dose", "given": false}
      ]
    },
    {
      "age": "9 Months",
      "vaccines": [
        {
          "name": "Measles, Mumps, and Rubella (MMR) - 1st Dose",
          "given": false
        },
        {"name": "Yellow Fever Vaccine", "given": false}
      ]
    },
    {
      "age": "12 Months",
      "vaccines": [
        {"name": "Hepatitis A - 1st Dose", "given": false}
      ]
    },
    {
      "age": "15 Months",
      "vaccines": [
        {"name": "MMR - 2nd Dose", "given": false},
        {"name": "Varicella Vaccine - 1st Dose", "given": false},
        {"name": "PCV Booster Dose", "given": false}
      ]
    },
    {
      "age": "18 Months",
      "vaccines": [
        {"name": "DTP Booster - 1st Dose", "given": false},
        {"name": "Hib Booster", "given": false},
        {"name": "Hepatitis A - 2nd Dose", "given": false}
      ]
    },
    {
      "age": "5 Years",
      "vaccines": [
        {"name": "DTP Booster - 2nd Dose", "given": false},
        {"name": "OPV Booster", "given": false},
        {"name": "Varicella Vaccine - 2nd Dose", "given": false}
      ]
    },
    {
      "age": "10-12 Years",
      "vaccines": [
        {"name": "HPV (Human Papillomavirus) Vaccine", "given": false},
        {"name": "TD (Tetanus, Diphtheria) Booster", "given": false}
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Vaccination Schedule",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.blue.shade900,
        centerTitle: true,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: vaccineSchedule.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              color: Colors.blue.shade50,
              child: ExpansionTile(
                title: Text(
                  vaccineSchedule[index]["age"],
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                children: (vaccineSchedule[index]["vaccines"]
                        as List<Map<String, dynamic>>)
                    .map((vaccine) => ListTile(
                          title: Text(
                            vaccine["name"],
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: vaccine["given"]
                                    ? Colors.green.shade700
                                    : Colors.red.shade700),
                          ),
                          leading: Icon(
                            vaccine["given"]
                                ? Icons.check_circle
                                : Icons.warning,
                            color: vaccine["given"] ? Colors.green : Colors.red,
                          ),
                          trailing: Switch(
                            activeColor: Colors.green,
                            inactiveThumbColor: Colors.red,
                            value: vaccine["given"],
                            onChanged: (bool value) {
                              setState(() {
                                vaccine["given"] = value;
                              });
                            },
                          ),
                        ))
                    .toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
