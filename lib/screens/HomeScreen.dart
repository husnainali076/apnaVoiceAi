import 'package:apnaai/Services/openAiServices.dart';
import 'package:apnaai/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';
import '../utils/featureBox.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FlutterTts flutterTts = FlutterTts();
  String? generatedContent;
  String? generateImgeUrl;
  final OpenAiServices openAiServices = OpenAiServices();
  final stt.SpeechToText speechToText = stt.SpeechToText();
  String lastWords = '';

  Future<void> initSpeechtoText() async {
    await speechToText.initialize();
    if (mounted) {
      setState(() {});
    }
  }
  Future<void> initTexttoSpeech() async
  {
    await flutterTts.setSharedInstance(true);
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    initSpeechtoText();
    initTexttoSpeech();
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }


  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    if (mounted) {
      setState(() {});
    }
  }
  Future<void> systemspeak(String content) async
  {
    await flutterTts.speak(content);
  }

  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          onPressed: (){},
          icon: const Icon(Icons.menu,color: Colors.black),

        ),
        title: const Text('Apna_AI'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
//profile picture
            Stack(
              children: [
                Center(
                  child:  Container(
                    height: 120,
                    width: 120,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: const BoxDecoration(
                      color: Pallete.assistantCircleColor,
                      shape: BoxShape.circle,
                    ),
                  ),


                ),
                Container(
                  height: 124,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/virtualAssistant.png')
                    )
                  ),
                )
              ],
            ),
            //chat bubble
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 40,

              ).copyWith(
                top: 30
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Pallete.borderColor
                ),
                borderRadius: BorderRadius.circular(20).copyWith(topLeft: Radius.zero),),
              child: Padding(
                padding: const EdgeInsets.symmetric(
    vertical: 10,

    ),
                child: Text(
                  generatedContent == null ? 'Good Morning, what task can I do for you?' : generatedContent!,
                  style: TextStyle(
                      color: Pallete.mainFontColor,
                      fontSize: 26,
                      fontFamily: 'Cera Pro'
                  ),
                ),

              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
               margin: EdgeInsets.only(top: 10,left: 22),
              child: Text(
                'Here are few more features',
                style: TextStyle(
                    fontFamily: 'Cera Pro',
                  color: Pallete.mainFontColor,
                   fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            //feature list
            Visibility(
              visible: generatedContent == null,
              child: Column(
                children: [
                  FeatureBox(colorF: Pallete.firstSuggestionBoxColor,headerText: 'Chat GPT', DecriptionText: 'A smarter way to become a pro in programming. I will work hard make my worth',),
                  FeatureBox(colorF: Pallete.secondSuggestionBoxColor, headerText: 'Dall-E', DecriptionText: 'A smarter way to become a pro in programming. I will work hard make my worth'),
                  FeatureBox(colorF: Pallete.thirdSuggestionBoxColor, headerText: 'Smart Voice Assistant', DecriptionText: 'A smarter way to become a pro in programming. I will work hard make my worth')
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.firstSuggestionBoxColor,
        child: Icon(Icons.mic),
        onPressed: () async
           {
    if (await speechToText.hasPermission && speechToText.isNotListening) {
    startListening();
    } else if (speechToText.isListening) {
    final speech = await openAiServices.isArtPromptApi(lastWords);

    if (speech.contains('https')) {
    generateImgeUrl = lastWords;
    generatedContent = null;
    setState(() {});
    } else {
    generatedContent = speech;
    generateImgeUrl = null;
    setState(() {});
    systemspeak(speech);
    }

    stopListening();
    } else {
    initSpeechtoText();
    }
    },

    ),
    );
  }
}
