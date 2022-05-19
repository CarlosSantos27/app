import 'package:futgolazo/src/components/widget/button_shadow_rounded.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'components/page_views.dart';
import 'package:futgolazo/src/routes/routes.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:futgolazo/src/components/widget/rive_button.dart';
import 'package:futgolazo/src/components/custom_scafold/statefull_custom.dart';

class OnboardingPageView extends StateFullCustom {
  OnboardingPageView({Key key}) : super(key: key);
  @override
  _OnboardingPageViewState createState() => _OnboardingPageViewState();
}

class _OnboardingPageViewState extends State<OnboardingPageView> {
  PageController _pageController;
  int currentPage;
  int cantPage;
  double valuePage = 0;
  List<Widget> listPage;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    this.currentPage = 0;
    this.listPage = this._getOnboardingScreeens();
    this.cantPage = this.listPage.length;

    _pageController.addListener(() {
      setState(() {
        this.valuePage = _pageController.page;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            PageView.builder(
              onPageChanged: (value) {
                setState(() {
                  this.currentPage = value;
                });
              },
              controller: _pageController,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, position) {
                return listPage[position];
              },
              itemCount: this.cantPage,
            ),
            _createFooterButton(),
            _createHeadeButton(),
          ],
        ),
      ),
    );
  }

  List<Widget> _getOnboardingScreeens() {
    List<Widget> listPage = new List<Widget>();
    listPage.add(InitInfoScreen());
    listPage.add(PetScreen());
    listPage.add(BallScreen());
    listPage.add(PetCollageScreen());
    return listPage;
  }

  void _gotoPage(BuildContext context, String pageRoute) async {
    GetIt.I<PoolServices>().dataService.playAsGuest();
    Navigator.pushNamed(context, pageRoute);
  }

  Widget _createHeadeButton() {
    String butonText = 'Ya tengo cuenta';
    return isMotLastPage()
        ? Align(
            alignment: Alignment.topRight,
            child: Container(
              height: widget.responsive.hp(7.77),
              margin: EdgeInsets.only(top: 10.0, right: 25.0),
              child: ButtonShadowRounded(
                width: widget.responsive.wp(42),
                child: Text(
                  butonText,
                  style: widget.fontSize
                      .bodyText2()
                      .copyWith(fontStyle: FontStyle.normal),
                ),
                onPressed: () => _gotoPage(context, NavigationRoute.SIGNIN),
              ),
            ),
          )
        : Container();
  }

  bool isMotLastPage() {
    return !(this.currentPage >= this.cantPage - 1);
  }

  Widget _createFooterButton() {
    return isMotLastPage()
        ? Container(
            margin: EdgeInsets.only(
              bottom: 12.0,
              right: 10.0,
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: _createCirularButton(
                () => _setActionFooterButton(),
              ),
            ),
          )
        : _creatButtonNewTeam();
  }

  Widget _creatButtonNewTeam() {
    String butonText = 'Escoger Equipo';
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: widget.responsive.wp(85),
        height: widget.responsive.hp(11),
        margin: EdgeInsets.only(bottom: 65),
        child: RiveButton(
          buttonText: butonText,
          style: widget.fontSize.headline3().copyWith(
                fontSize: widget.responsive.ip(2.70),
                color: widget.colorsTheme.getColorOnSecondary,
                letterSpacing: 0.6,
              ),
          responsive: widget.responsive,
          onTapButton: () => _gotoPage(context, NavigationRoute.USER_TEAM),
        ),
      ),
    );
  }

  void _setActionFooterButton() {
    if (isMotLastPage()) {
      this.currentPage += 1;
      _pageController.nextPage(
        duration: Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Widget _createCirularButton(VoidCallback callback) {
    return RaisedButton(
      child: Container(
        width: widget.responsive.ip(13),
        height: widget.responsive.ip(13),
        child: Icon(
          Icons.chevron_right,
          color: widget.colorsTheme.getColorOnButton,
          size: widget.responsive.ip(4),
        ),
      ),
      shape: CircleBorder(),
      elevation: 1.0,
      color: widget.colorsTheme.getColorOnSecondary,
      onPressed: callback,
    );
  }
}
