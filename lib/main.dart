import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simpsons_ep/models/Episode.dart';

var headerColor = Colors.white;
var subHeaderColor = Color.fromARGB(180, 255, 255, 255);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 88, 86, 91)),
        useMaterial3: true,
      ),
      home: SimpsonsEP(),
    );
  }
}

class SimpsonsEP extends StatefulWidget {
  const SimpsonsEP({Key? key});

  @override
  State<SimpsonsEP> createState() => _SimpsonsEPState();
}

class _SimpsonsEPState extends State<SimpsonsEP> {
  List<episodes>? _ep;

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 47, 48, 48),
      title: Text(
        'Simpsons All Episodes',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 240, 238, 238),
        ),
      ),
    );
  }

  void _getAPI() async {
    try {
      var dio = Dio(BaseOptions(responseType: ResponseType.plain));
      var response =
          await dio.get('https://api.sampleapis.com/simpsons/episodes');
      print('Status code: ${response.statusCode}');

      List<dynamic> list = jsonDecode(response.data.toString());

      setState(() {
        _ep = list.map((item) => episodes.fromJson(item)).toList();
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _getAPI();
  }

  Widget _titleBuild(var ep) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(64.0, 0.0, 64.0, 15.0),
      child: Text(
        'Episode ${ep.episode} - ${ep.name ?? ''}',
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: headerColor,
        ),
      ),
    );
  }

  Widget _subtitleBuild(var ep) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(64.0, 0.0, 64.0, 20.0),
      child: Text(
        ep.description ?? '',
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: subHeaderColor,
        ),
      ),
    );
  }

  Widget _rateStar(var ep) {
    var rating = ep.rating.round() ?? 0.0;
    var starCount = (rating / 2).toInt();

    return Row(
      children: List.generate(
        5,
        (index) {
          if (index < starCount) {
            return Icon(Icons.star, color: Colors.yellow, size: 50);
          } else {
            return Icon(Icons.star, color: Colors.black, size: 50);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Center(
        child: Container(
          child: _buildEpList()
          )
        ),
    );
  }

  Widget _buildEpList() {
    return _ep == null
        ? SizedBox.shrink()
        : Center(
            child: ListView.builder(
              itemCount: _ep!.length,
              itemBuilder: (context, index) {
                var ep = _ep![index];
                return _buildEpisodeItem(ep);
              },
            ),
          );
  }

  Widget _buildEpisodeItem(var ep) {
    return Material(
      color: Colors.black,
      child: InkWell(
        splashColor: const Color.fromARGB(177, 255, 255, 255),
        hoverColor: Color.fromARGB(255, 103, 103, 103),
        onTap: () {
          _showEpisodeDetailsDialog(ep);
        },
          child: ListTile(
            title: _titleBuild(ep),
            subtitle: _subtitleBuild(ep),
            trailing: ep.thumbnailUrl == ''
                ? null
                : Image.network(
                    ep.thumbnailUrl ?? '',
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.error,
                        color: Colors.red,
                      );
                    },
                  ),
          ),
      ),
    );
  }

  void _showEpisodeDetailsDialog(var ep) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromARGB(217, 68, 65, 65),
        title: Text(
          ep.name ?? '',
          style: GoogleFonts.poppins(
            color: headerColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ep.description ?? '',
                style: GoogleFonts.poppins(color: subHeaderColor),
              ),
              Text(ep.rating.toString()),
              _rateStar(ep),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('CANCEL', style: GoogleFonts.poppins(color: headerColor)),
            onPressed: ()=> Navigator.pop(context),
          )
        ],
      ),
      
    );
  }
}
